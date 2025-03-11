import type { Config } from "jest";

export default async (): Promise<Config> => {
    return {
        verbose: true,
        transform: {
            "^.+\\.tsx?$": "ts-jest"
        },
        testRegex: "(/__tests__/.*|(\\.|/)(test|spec))\\.(jsx?|tsx?)$",
        moduleFileExtensions: [
            "ts",
            "tsx",
            "js",
            "jsx",
            "json",
            "node"
        ]
    }
}